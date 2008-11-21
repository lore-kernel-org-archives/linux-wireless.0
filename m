Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:8028 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbYKUUfC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 15:35:02 -0500
Received: by nf-out-0910.google.com with SMTP id d3so558342nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2008 12:34:59 -0800 (PST)
Message-ID: <49271B6D.3060406@gmail.com> (sfid-20081121_213509_966992_A27D7EC0)
Date: Fri, 21 Nov 2008 22:34:53 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] Bugs in ath5k on aspire one (AR2425)
References: <492712D9.7080004@gmail.com> <49271749.1060601@tuffmail.co.uk>
In-Reply-To: <49271749.1060601@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alan Jenkins wrote:
> Maxim Levitsky wrote:
>> Hi,
>>
>> I captured few errors in dmesg, will post them here.
>> If I see more errors, I add them to this thread.
>>
>>
>> [   69.516498] ath5k phy0: gain calibration timeout (2412MHz)
>> [   69.516509] ath5k phy0: can't reset hardware (-11)
>> [   69.516516] phy0: failed to restore operational channel after scan
>> [   69.628572] ath5k phy0: noise floor calibration failed (2412MHz)
>> [   69.686894] ath5k phy0: noise floor calibration failed (2417MHz)
>> [   69.770067] ath5k phy0: noise floor calibration failed (2417MHz)
>> [   70.419785] ath5k phy0: gain calibration timeout (2422MHz)
>> [   70.419800] ath5k phy0: can't reset hardware (-11)
>> [   70.419809] phy0: failed to set freq to 2422 MHz for scan
>> [   71.356436] ath5k phy0: gain calibration timeout (2427MHz)
>> [   71.356450] ath5k phy0: can't reset hardware (-11)
>> [   71.356458] phy0: failed to set freq to 2427 MHz for scan
>> [   72.119219] ath5k phy0: gain calibration timeout (2432MHz)
>> [   72.119234] phy0: failed to set freq to 2432 MHz for scan
>> [   72.764447] phy0: failed to set freq to 2437 MHz for scan
>> [   73.410438] phy0: failed to set freq to 2442 MHz for scan
>> [   74.027807] phy0: failed to set freq to 2447 MHz for scan
>> [   74.640495] __ratelimit: 7 callbacks suppressed
>> [   74.640504] ath5k phy0: gain calibration timeout (2452MHz)
>> [   74.640511] ath5k phy0: can't reset hardware (-11)
>> [   74.640517] phy0: failed to set freq to 2452 MHz for scan
>> [   75.256551] ath5k phy0: gain calibration timeout (2457MHz)
>> [   75.256565] ath5k phy0: can't reset hardware (-11)
>> [   75.256573] phy0: failed to set freq to 2457 MHz for scan
>> [   75.874414] ath5k phy0: gain calibration timeout (2462MHz)
>> [   75.874424] ath5k phy0: can't reset hardware (-11)
>> [   75.874430] phy0: failed to set freq to 2462 MHz for scan
>> [   76.488436] ath5k phy0: gain calibration timeout (2412MHz)
>> [   76.488447] ath5k phy0: can't reset hardware (-11)
>> [   76.488452] phy0: failed to restore operational channel after scan
>> [   76.488543] wlan0: authenticate with AP 00:1b:9e:d8:77:02
>> [   76.688125] wlan0: authenticate with AP 00:1b:9e:d8:77:02
>> [   76.889098] wlan0: authenticate with AP 00:1b:9e:d8:77:02
>> [   77.088122] wlan0: authentication with AP 00:1b:9e:d8:77:02 timed out
>> [   78.415786] ath5k phy0: noise floor calibration timeout (2417MHz)
>> [   78.810771] ath5k phy0: gain calibration timeout (2417MHz)
>> [   78.810782] phy0: failed to set freq to 2417 MHz for scan
>> [   79.427510] phy0: failed to set freq to 2422 MHz for scan
>> [   80.056900] __ratelimit: 3 callbacks suppressed
>> [   80.056910] ath5k phy0: gain calibration timeout (2427MHz)
>> [   80.056919] ath5k phy0: can't reset hardware (-11)
>> [   80.056925] phy0: failed to set freq to 2427 MHz for scan
>> [   80.670529] ath5k phy0: gain calibration timeout (2432MHz)
>> [   80.670540] ath5k phy0: can't reset hardware (-11)
>> [   80.670546] phy0: failed to set freq to 2432 MHz for scan
>> [   81.285272] ath5k phy0: gain calibration timeout (2437MHz)
>> [   81.285285] ath5k phy0: can't reset hardware (-11)
>> [   81.285294] phy0: failed to set freq to 2437 MHz for scan
>> [   81.911449] ath5k phy0: gain calibration timeout (2442MHz)
>> [   81.911461] ath5k phy0: can't reset hardware (-11)
>> [   81.911470] phy0: failed to set freq to 2442 MHz for scan
>> [   82.526023] ath5k phy0: gain calibration timeout (2447MHz)
>> [   82.526034] ath5k phy0: can't reset hardware (-11)
>> [   82.526040] phy0: failed to set freq to 2447 MHz for scan
>> [   83.141962] phy0: failed to set freq to 2452 MHz for scan
>> [   83.759025] phy0: failed to set freq to 2457 MHz for scan
>> [   84.373688] phy0: failed to set freq to 2462 MHz for scan
>> [   84.990322] phy0: failed to restore operational channel after scan
>> [   89.419876] __ratelimit: 8 callbacks suppressed
>> [   89.419890] ath5k phy0: noise floor calibration timeout (2412MHz)
>> [   90.087509] ath5k phy0: gain calibration timeout (2417MHz)
>> [   90.087519] ath5k phy0: can't reset hardware (-11)
>> [   90.087525] phy0: failed to set freq to 2417 MHz for scan
>> [   90.700892] ath5k phy0: gain calibration timeout (2422MHz)
>> [   90.700903] ath5k phy0: can't reset hardware (-11)
>> [   90.700909] phy0: failed to set freq to 2422 MHz for scan
>> [   91.315752] ath5k phy0: gain calibration timeout (2427MHz)
>> [   91.315763] ath5k phy0: can't reset hardware (-11)
>> [   91.315770] phy0: failed to set freq to 2427 MHz for scan
>> [   91.935144] ath5k phy0: gain calibration timeout (2432MHz)
>> [   91.935155] ath5k phy0: can't reset hardware (-11)
>> [   91.935161] phy0: failed to set freq to 2432 MHz for scan
>> [   92.550491] ath5k phy0: gain calibration timeout (2437MHz)
>> [   92.550505] phy0: failed to set freq to 2437 MHz for scan
>> [   93.220305] phy0: failed to set freq to 2442 MHz for scan
>> [   93.837228] phy0: failed to set freq to 2447 MHz for scan
>> [   94.450800] phy0: failed to set freq to 2452 MHz for scan
>> [   95.069019] phy0: failed to set freq to 2457 MHz for scan
>> [   95.690239] __ratelimit: 9 callbacks suppressed
>> [   95.690251] ath5k phy0: gain calibration timeout (2462MHz)
>> [   95.690261] ath5k phy0: can't reset hardware (-11)
>> [   95.690269] phy0: failed to set freq to 2462 MHz for scan
>> [   96.305163] ath5k phy0: gain calibration timeout (2412MHz)
>> [   96.305173] ath5k phy0: can't reset hardware (-11)
>> [   96.305179] phy0: failed to restore operational channel after scan
>> [  100.084643] ath5k phy0: noise floor calibration failed (2412MHz)
>> [  100.689317] ath5k phy0: gain calibration timeout (2417MHz)
>> [  100.689328] ath5k phy0: can't reset hardware (-11)
>> [  100.689334] phy0: failed to set freq to 2417 MHz for scan
>> [  101.308123] ath5k phy0: gain calibration timeout (2422MHz)
>> [  101.308134] ath5k phy0: can't reset hardware (-11)
>> [  101.308140] phy0: failed to set freq to 2422 MHz for scan
>> [  101.923409] ath5k phy0: gain calibration timeout (2427MHz)
>> [  101.923419] ath5k phy0: can't reset hardware (-11)
>> [  101.923425] phy0: failed to set freq to 2427 MHz for scan
>> [  102.536898] ath5k phy0: gain calibration timeout (2432MHz)
>> [  102.536911] ath5k phy0: can't reset hardware (-11)
>> [  102.536920] phy0: failed to set freq to 2432 MHz for scan
>> [  103.153227] ath5k phy0: gain calibration timeout (2437MHz)
>> [  103.153238] ath5k phy0: can't reset hardware (-11)
>> [  103.153244] phy0: failed to set freq to 2437 MHz for scan
>> [  103.766742] ath5k phy0: gain calibration timeout (2442MHz)
>> [  103.766753] ath5k phy0: can't reset hardware (-11)
>> [  103.766759] phy0: failed to set freq to 2442 MHz for scan
>> [  104.382792] phy0: failed to set freq to 2447 MHz for scan
>> [  104.998713] phy0: failed to set freq to 2452 MHz for scan
>> [  105.612695] phy0: failed to set freq to 2457 MHz for scan
>> [  106.227980] phy0: failed to set freq to 2462 MHz for scan
>> [  106.846579] __ratelimit: 8 callbacks suppressed
>> [  106.846591] ath5k phy0: gain calibration timeout (2412MHz)
>> [  106.846601] ath5k phy0: can't reset hardware (-11)
>> [  106.846609] phy0: failed to restore operational channel after scan
>> [  111.388603] ath5k phy0: noise floor calibration failed (2412MHz)
>> [  112.002756] ath5k phy0: gain calibration timeout (2417MHz)
>> [  112.002769] ath5k phy0: can't reset hardware (-11)
>> [  112.002776] phy0: failed to set freq to 2417 MHz for scan
>> [  112.618112] ath5k phy0: gain calibration timeout (2422MHz)
>> [  112.618123] ath5k phy0: can't reset hardware (-11)
>> [  112.618129] phy0: failed to set freq to 2422 MHz for scan
>> [  113.234943] ath5k phy0: gain calibration timeout (2427MHz)
>> [  113.234957] ath5k phy0: can't reset hardware (-11)
>> [  113.234965] phy0: failed to set freq to 2427 MHz for scan
>> [  113.855231] ath5k phy0: gain calibration timeout (2432MHz)
>> [  113.855242] ath5k phy0: can't reset hardware (-11)
>> [  113.855248] phy0: failed to set freq to 2432 MHz for scan
>>
>> Happened on boot, and card stopped working.
>> Only a reboot helped.
>>   
> 
> A patch has been submitted which stops the card getting wedged this way,
> 
> <http://www.spinics.net/lists/linux-wireless/msg23404.html>
> 
> from the messages it's not clear whether this is a complete fix, or more
> of a workaround for an underlying problem.  It sounds like it got an ACK
> from another tester (and I can add mine as well!), but no-one has
> accepted or reviewed it :(.
> 
>> When transferring large amounts of data from/to desktop pc, 
>> assotiation with ap is dropped often which results is minute/two of no wireless
>> activety and this:
>>
>> [ 1522.872096] wlan0: direct probe to AP 00:1b:9e:d8:77:02 try 1
>> [ 1523.072094] wlan0: direct probe to AP 00:1b:9e:d8:77:02 try 2
>> [ 1523.268098] wlan0: direct probe to AP 00:1b:9e:d8:77:02 try 3
>> [ 1523.477204] wlan0: direct probe to AP 00:1b:9e:d8:77:02 timed out
>> [ 1524.569452] wlan0: authenticate with AP 00:1b:9e:d8:77:02
>> [ 1524.571157] wlan0: authenticated
>> [ 1524.571179] wlan0: associate with AP 00:1b:9e:d8:77:02
>> [ 1524.574284] wlan0: RX ReassocResp from 00:1b:9e:d8:77:02 (capab=0x411 status=0 aid=1)
>>
>>
>>
>> Also when downloading from AP (from desktop) I see this:
>>
>> ath5k phy0: unsupported jumbo
>>   
> 
> Known issue, just what it says on the tin.  There used to be a bug here,
> but it's fixed now.  Just an unsupported performance feature which you
> should be able to live without, for the time being :).
> 
> (the bugfix thread is here, it confirms the intention to ignore jumbo
> frames <http://thread.gmane.org/gmane.linux.kernel.wireless.general/23383>).
> 
> Regards
> Alan
The problem is that I have this patch applied...
This says something about gain calibration timeout.

Best regards,
	Maxim Levitsky


