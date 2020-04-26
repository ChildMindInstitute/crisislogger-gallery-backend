<?php

namespace App;

use Carbon\CarbonImmutable;
use Google\ApiCore\ApiException;
use Google\ApiCore\ValidationException;
use Google\Cloud\Speech\V1\RecognitionAudio;
use Google\Cloud\Speech\V1\RecognitionConfig;
use Google\Cloud\Speech\V1\RecognitionConfig\AudioEncoding;
use Google\Cloud\Speech\V1\SpeechClient;
use Illuminate\Contracts\Filesystem\FileNotFoundException;
use Illuminate\Database\Eloquent\Model;
use Auth;
use Storage;
use Eloquent;

/**
 * Class Transcription
 * @package App
 * @mixin Eloquent
 * @property int id
 * @property int user_id
 * @property int upload_id
 * @property string text
 * @property CarbonImmutable created_at
 * @property CarbonImmutable updated_at
 */
class Transcription extends Model {

}
