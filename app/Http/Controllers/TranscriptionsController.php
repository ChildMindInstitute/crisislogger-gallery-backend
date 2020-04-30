<?php

namespace App\Http\Controllers;

use App\Transcription;
use App\User;
use Illuminate\Http\Request;

class TranscriptionsController extends Controller {


	public function index(Request $request) {
		$referral_code = $request->referralCode;
		$transcriptions = Transcription::leftJoin('uploads', 'uploads.id', '=', 'transcriptions.upload_id')
			->where('uploads.share', '>', '0')
			->where('uploads.hide', '=', '0');
		if ($referral_code != null) {
			$transcriptions = $transcriptions->leftJoin('users', 'users.id', '=', 'uploads.user_id')
				->where('users.referral_code', 'like', "%$referral_code%");
		}
		return $transcriptions->orderBy('uploads.converted', 'DESC')
			->select('uploads.*', 'transcriptions.*')
			->paginate(8);
	}

	public function create() {

	}

	public function store(Request $request) {

	}

	public function show($id) {

	}

	public function edit($id) {

	}

	public function update(Request $request, $id) {

	}

	public function destroy($id) {

	}
}
