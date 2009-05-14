Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:48914 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbZENAhp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 20:37:45 -0400
Received: by rv-out-0506.google.com with SMTP id f9so583347rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 17:37:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69e28c910905131731t5f708339y3fc87b9035591115@mail.gmail.com>
References: <43e72e890905131718k739eef2eu35f76d4bf5b03dae@mail.gmail.com>
	<69e28c910905131731t5f708339y3fc87b9035591115@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 13 May 2009 17:37:25 -0700
Message-ID: <43e72e890905131737l757b2e9cm166f67932677c5ac@mail.gmail.com>
Subject: Re: WoW for ath5k
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: "ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/5/13 G=C3=A1bor Stefanik <netrolller.3d@gmail.com>:
> On Thu, May 14, 2009 at 2:18 AM, Luis R. Rodriguez <mcgrof@gmail.com>=
 wrote:
>> BTW legacy-hal has this stuff :) Just grep for ATH_WOW
>>
>> =C2=A0Luis
>
> Wow! :-)

Oh and as for testing... we should see the card send null data frames
every now and then. That's when we know it went into its WoW mode.

 Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
