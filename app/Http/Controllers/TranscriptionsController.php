<?php

namespace App\Http\Controllers;

use App\Transcription;
use Illuminate\Http\Request;

class TranscriptionsController extends Controller {


	public function index() {
		return Transcription::leftJoin('uploads', 'uploads.id', '=', 'transcriptions.upload_id')
			->where('uploads.share', '>', '0')
			->where('uploads.hide', '=', '0')
			->orderBy('transcriptions.id', 'DESC')
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
