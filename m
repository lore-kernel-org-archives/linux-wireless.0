Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:7146 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbZDFTsX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2009 15:48:23 -0400
Received: by wf-out-1314.google.com with SMTP id 29so2403995wff.4
        for <linux-wireless@vger.kernel.org>; Mon, 06 Apr 2009 12:48:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890904031128i7c14d809q93dee61ba964c717@mail.gmail.com>
References: <1238711166-2208-1-git-send-email-lrodriguez@atheros.com>
	<1238711166-2208-3-git-send-email-lrodriguez@atheros.com>
	<69e28c910904030801k7fb2794bodaea74bb551dbcea@mail.gmail.com>
	<43e72e890904031127s5223e0a3w7647ce2b0424129c@mail.gmail.com>
	<43e72e890904031128i7c14d809q93dee61ba964c717@mail.gmail.com>
Date: Mon, 6 Apr 2009 12:48:06 -0700
Message-ID: <43e72e890904061248u1be026b5n2c5a47cec025581@mail.gmail.com> (sfid-20090406_214826_765847_66E21576)
Subject: Re: [PATCH 2/5] wireless: rename IEEE80211_CHAN_NO_FAT_* to HT40-/+
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 3, 2009 at 11:28 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> 2009/4/3 Luis R. Rodriguez <lrodriguez@atheros.com>:
>> 2009/4/3 G=C3=A1bor Stefanik <netrolller.3d@gmail.com>:
>>> Greetings!
>>>
>>> I think that other references to "fat" should be removed as well, i=
n
>>> favor of "HT40".
>>
>> Heh I take it you didn't get to patch #3?
>
> Oh wait, never mind. I'll address this.

Eh I won't have time to rename that stuff but please feel free to send
on top. I'll post a new series in a bit.

 Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
