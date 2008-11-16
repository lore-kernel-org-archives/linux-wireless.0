Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:12305 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbYKPU6p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2008 15:58:45 -0500
Received: by fg-out-1718.google.com with SMTP id 19so1850143fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 16 Nov 2008 12:58:43 -0800 (PST)
Message-ID: <2da21fe50811161258v58efe236r492d59c8b9228b81@mail.gmail.com> (sfid-20081116_215854_249874_B0642317)
Date: Sun, 16 Nov 2008 21:58:43 +0100
From: "Davide Pesavento" <davidepesa@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: crda packaging
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <43e72e890810191828x44624d4fsa8d56170d2ba4f46@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <2da21fe50810190857j4dacb612u3a2bba4ab3baa7fd@mail.gmail.com>
	 <43e72e890810191828x44624d4fsa8d56170d2ba4f46@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 20, 2008 at 02:28, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Sun, Oct 19, 2008 at 8:57 AM, Davide Pesavento <davidepesa@gmail.com> wrote:
>>
>> Do you think the regulatory database should be split from the package
>> that contains the crda daemon? If so, regulatory.bin should be
>> versioned as well...
>
> Yes, absolutely, the idea is to split db.txt into a separate git tree
> too actually so that should help with keeping track of changes
> separately and thinking of them separately.
>
> We just need to get this git tree created. What crda will need though
> is to wget the RSA public key so it can be built with support for new
> arbitrary updates to the binary db. Give us a few days, we'll get this
> setup.
>
>  Luis
>

Any updates on this?

Davide
