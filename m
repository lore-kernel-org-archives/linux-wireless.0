Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db3on0085.outbound.protection.outlook.com ([157.55.234.85]:16198
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751932AbbCVVV4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2015 17:21:56 -0400
From: Stefano Cappa <stefano.cappa@mail.polimi.it>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: informations about Linux wifi driver's architecture today
Date: Sun, 22 Mar 2015 21:21:54 +0000
Message-ID: <1427059313289.43792@mail.polimi.it> (sfid-20150322_222200_438584_6B68C164)
References: <1427048376242.67051@mail.polimi.it>,<CAMowtuMgAPsgAKuwSibjAzhDbqEdZGatikCiKks6f3w=4oth+Q@mail.gmail.com>
In-Reply-To: <CAMowtuMgAPsgAKuwSibjAzhDbqEdZGatikCiKks6f3w=4oth+Q@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi 
I prefer a generic version, without specific things, like this one: h**p://postimg.org/image/hfkpjt3ux/ created by Johannes Berg.

And, if available something for the broadcom chip bcm4339.

Thank you.

________________________________________
Da: Kathy Giori <kathy.giori@gmail.com>
Inviato: domenica 22 marzo 2015 19.35
A: Stefano Cappa
Cc: linux-wireless@vger.kernel.org
Oggetto: Re: informations about Linux wifi driver's architecture today

On Sun, Mar 22, 2015 at 11:19 AM, Stefano Cappa
<stefano.cappa@mail.polimi.it> wrote:
> Hi!
> some months ago, i saw the presentation of Johannes Berg in PDF, but now it isn't available, probably because it's very old.
>
> This slides will be updated to a new release?
>
> I have this slide and in page 5/35 (2009-02-26) there is the "Architecture - planned". This is the actual architecture or there are some differences in 2015? If yes, where i can find the new version of this page, with a little diagram?

Ciao Stefano,

Perhaps Johannes can post a current overview diagram on the Linux
wireless wiki (if you share with him which diagram you want to be
updated).

In terms of vendor-specific architecture, and how it fits in, Kalle
Valo posted a high-level diagram for ath10k:
https://wireless.wiki.kernel.org/en/users/drivers/ath10k/architecture

Are you mainly interested in the architecture of vendor-agnostic upper
layers or a description of a specific vendor driver?
kg