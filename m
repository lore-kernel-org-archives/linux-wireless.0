Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.187]:45956 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbZDZONh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Apr 2009 10:13:37 -0400
MIME-Version: 1.0
In-Reply-To: <49F43975.2060106@gmail.com>
References: <1240661363-16631-1-git-send-email-jirislaby@gmail.com>
	 <20090426020047.GA10885@hash.localnet> <49F43975.2060106@gmail.com>
Date: Sun, 26 Apr 2009 17:13:35 +0300
Message-ID: <40f31dec0904260713o97f5cs95f87d72e8772e64@mail.gmail.com> (sfid-20090426_161341_757893_4534F294)
Subject: Re: [PATCH 1/1] ath5k: 5211, don't crypt every protected frame
From: Nick Kossifidis <mickflemm@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/26 Jiri Slaby <jirislaby@gmail.com>:
> On 04/26/2009 04:00 AM, Bob Copeland wrote:
>> On Sat, Apr 25, 2009 at 02:09:23PM +0200, Jiri Slaby wrote:
>>> Hi guys,
>>> do you remember some 5211 HW which didn't work with this?
>>> --
>>>
>>> Set null key type even on ar5211, otherwise it en/decrypts every fr=
ame with
>>> protected bit set which renders the card unusable on encrypted netw=
orks.
>>
>> Not me. =C2=A0I don't have the hardware, so I would say if your patc=
h is known
>> to work on a 5211 then we go with it.
>
> Ok, thanks. Of course the HW I used (IBM T40 Thinkpad) needs the patc=
h ;).
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

--=20
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
