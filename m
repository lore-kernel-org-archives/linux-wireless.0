Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:64939 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbYA1R30 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 12:29:26 -0500
Received: by an-out-0708.google.com with SMTP id d31so383230and.103
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2008 09:29:26 -0800 (PST)
Message-ID: <479E1094.2080804@gmail.com> (sfid-20080128_172931_588021_A1C061D5)
Date: Mon, 28 Jan 2008 11:27:48 -0600
From: "Jory A. Pratt" <geekypenguin@gmail.com>
MIME-Version: 1.0
To: Larry Finger <larry.finger@lwfinger.net>
CC: Stefano Brivio <stefano.brivio@polimi.it>,
	"John W. Linville" <linville@tuxdriver.com>,
	Lars Ericsson <Lars_Ericsson@telia.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFT] [PATCH] rc80211-pid: fix rate adjusting
References: <20080127204606.63fbbaf7@morte> <479E047A.4080603@lwfinger.net>
In-Reply-To: <479E047A.4080603@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> Stefano Brivio wrote:
>> Merge rate_control_pid_shift_adjust() to rate_control_pid_adjust_rate()
>> in order to make the learning algorithm aware of constraints on 
>> rates. Also
>> add some comments and rename variables.
>>
>> This fixes a bug which prevented 802.11b/g non-AP STAs from working with
>> 802.11b only AP STAs.
>>
>> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
>> ---
>> John, this should supersede the previously posted patches 1/2 and 
>> 2/2. This
>> needs further testing anyway.
>>
>> Larry, Lars, please test this. It works for me, both with 802.11b 
>> only and
>> 802.11b/g settings on my AP.
>
> Now that ieee80211_sta_work() no longer crashes on my machine, I have 
> been able to test this patch. So far, it seems to work.
>
> Larry

Works just fine here as well.

-Jory
