Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:36625 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758332AbZGGQPb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 12:15:31 -0400
Received: by an-out-0708.google.com with SMTP id d40so12517956and.1
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jul 2009 09:15:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090707144851.GA2768@tuxdriver.com>
References: <4A49EEC3.3060108@mrs.ro> <43e72e890906300920j1963ae07v800468db9a908a1@mail.gmail.com>
	<4A4B056B.9000602@mrs.ro> <43e72e890907011033r52c4256dtecf603f56213a825@mail.gmail.com>
	<4A530131.9050207@mrs.ro> <4A532D3C.5060601@antacs.com> <20090707144851.GA2768@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 7 Jul 2009 09:15:10 -0700
Message-ID: <43e72e890907070915y5fd131b7l6aa845a0785f8c76@mail.gmail.com>
Subject: Re: mac80211 and broadcast frames
To: "John W. Linville" <linville@tuxdriver.com>
Cc: David Ross <dave@antacs.com>,
	Valentin Manea <linux-wireless@mrs.ro>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 7, 2009 at 7:48 AM, John W. Linville<linville@tuxdriver.com> wrote:
> On Tue, Jul 07, 2009 at 09:10:52PM +1000, David Ross wrote:
>> Actually it is required to be a mutual BASIC rate (not extended rates) -
>> not necessarily the "lowest possible" - David.
>
> True, but FWIW I think all of our rate scaling algorithms choose the
> lowest rate.

And then iwlwifi and ath9k have their own rate control algo, and at
least ath9k uses the lowest valid rate IIRC.

  Luis
