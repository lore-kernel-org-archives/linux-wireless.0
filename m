Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:35799 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbbDHTTX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2015 15:19:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAGrUaU1D_tO9+HrH_mEa0U13xTCuOijyvcn2_mi8cUgkkPeOuw@mail.gmail.com>
References: <CAGrUaU24vCH6+GpAtBCNiGwdT4_-FNNLDq=_s5zhSPBOp8bbmg@mail.gmail.com>
	<21764.61660.411242.223378@gargle.gargle.HOWL>
	<CAGrUaU1D_tO9+HrH_mEa0U13xTCuOijyvcn2_mi8cUgkkPeOuw@mail.gmail.com>
Date: Wed, 8 Apr 2015 12:19:22 -0700
Message-ID: <CAJ-VmokVe0dO1kHh8u0ok3G6V70cj-i8qeKHyMRpnWeDEK4w9Q@mail.gmail.com> (sfid-20150408_211926_708851_A682C546)
Subject: Re: [ath9k-devel] ath9k channel switch
From: Adrian Chadd <adrian@freebsd.org>
To: Saurabh Pal <saurabh6321@gmail.com>
Cc: Sujith Manoharan <sujith@msujith.org>, netdev@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

You can do a fast channel switch under very specific conditions. It
includes but isn't limited to being on the same band (ie, no fast cc
between 2/5ghz.)


-adrian
