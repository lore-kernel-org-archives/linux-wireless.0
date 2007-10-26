Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:17105 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbXJZX7N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 19:59:13 -0400
Received: by py-out-1112.google.com with SMTP id u77so1694443pyb
        for <linux-wireless@vger.kernel.org>; Fri, 26 Oct 2007 16:59:12 -0700 (PDT)
Message-ID: <40f31dec0710261658n6a322a01u5f8a1b00c90f020c@mail.gmail.com> (sfid-20071027_005917_169279_60205E77)
Date: Sat, 27 Oct 2007 02:58:58 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath5k-devel] [PATCH 1/2] ath5k: Maintain coding style
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	mcgrof@gmail.com, jirislaby@gmail.com
In-Reply-To: <40f31dec0710260228r117c8ccdy13a8c32ffd42c2db@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071021013630.GB5817@localhost.domain.invalid>
	 <20071026024348.GA14080@tuxdriver.com>
	 <40f31dec0710260228r117c8ccdy13a8c32ffd42c2db@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/10/26, Nick Kossifidis <mickflemm@gmail.com>:
> 2007/10/25, John W. Linville <linville@tuxdriver.com>:
> > On Sun, Oct 21, 2007 at 01:36:30AM +0000, Nick Kossifidis wrote:
> > > * Sort functions in segments like we do on the rest of the code (eg.
> > > hw.c). This improves readability and maintainability.
> > >
> > > * Add myself as module author (a patch for this was submited some time
> > > ago as part of SFLC's changes but wasn't applied)
> > >
> > > * Declare that this driver is or 5xxx chipset series only in
> > > MODULE_SUPPORTED_DEVICE and MODULE_DESCRIPTION.
> >
> > This patch and the next one do not apply.  Further, after manually
> > fixing-up this patch it removes a bunch of functions that are still
> > used.
> >
> > Would you mind re-diffing and trying again?
> >
> > Thanks,
> >
> > John
>
> ACK ;-)
>

Do you mind if i also send the rest of them on the same series (not
only cleanups but code changes also) ?

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
