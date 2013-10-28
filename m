Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:52333 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab3J1S3O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 14:29:14 -0400
Received: by mail-we0-f169.google.com with SMTP id q58so7157660wes.28
        for <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 11:29:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMP44s2Cvw9HF3c3Asuq+bTSD36Gw6PXOUVjAcCD+hf6KB_awg@mail.gmail.com>
References: <CAMP44s1XJRHV8bAX=_-TkSKMkY8Nw1=eHorqTCZ2QmtR5m8uJA@mail.gmail.com>
 <526E20EA.9090203@rempel-privat.de> <CAMP44s2Cvw9HF3c3Asuq+bTSD36Gw6PXOUVjAcCD+hf6KB_awg@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 28 Oct 2013 23:58:52 +0530
Message-ID: <CABPxzY+xJ7kst-sYwP8RJwMO_zkNYWKaYy=_LS7WQfuxquK24w@mail.gmail.com> (sfid-20131028_192919_839201_85944DC6)
Subject: Re: I always need a miracle to connect with iwlwifi
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>, ilw@linux.intel.com,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 28, 2013 at 11:30 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:

> The authentication response does come back in both cases though, it's
> just the acknowledgement that is missing. Unfortunately I cannot
> figure out for which message it's the ack.
>
> Also, I notice the sequence number received from the router doesn't
> seem to change. All the authentication requests received have the same
> number (256). Another peculiar thing is that in the failed case the SN
> we send starts with 0.
>
> I suppose since the authentication ack never arrives, the next steps
> are never completed.
>
> Does that help?
>From the supplicant logs we have successfully received the
authentication response
and sent out the association request. So are you referring to not receiving ACK
for association request??

It would be nice to get the capture without any filters?




-- 
Thanks,
Regards,
Chaitanya T K.
Mobile:+91-9963910010.
