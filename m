Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:53437 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbZCYMuq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 08:50:46 -0400
Received: by fg-out-1718.google.com with SMTP id e12so11296fga.17
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 05:50:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200903251345.01608.chunkeey@web.de>
References: <1237959016-17311-1-git-send-email-jcmvbkbc@gmail.com>
	 <200903251221.38912.chunkeey@web.de>
	 <73aaf0dd0903250500g51494e04iab9382e23d44f695@mail.gmail.com>
	 <200903251345.01608.chunkeey@web.de>
Date: Wed, 25 Mar 2009 15:50:44 +0300
Message-ID: <73aaf0dd0903250550x37e6847x38be1f0dcc4b1bb3@mail.gmail.com> (sfid-20090325_135057_114254_83C2963E)
Subject: Re: [PATCH 2/2 v2] p54spi: fix p54spi_upload_firmware
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Sorry, I haven't been used to checkpatch.
> But your PATCH 1/2 sailed through without any complains. ;-)
Mere coincidence (:

> BTW: does p54spi really work now?
I haven't tested your patch yet, but with the one that I sent it does
work in IBSS mode.
My aim is to wind it up in mesh mode. This doesn't work, it cannot
establish peer link.
I'm going to investigate it. Does mesh mode work on conventional pci/usb p54?

--
Max
