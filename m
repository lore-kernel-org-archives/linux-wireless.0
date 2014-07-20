Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:47633 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaGTLKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 07:10:07 -0400
Received: by mail-oa0-f43.google.com with SMTP id i7so5988345oag.16
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 04:10:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1405854022-11833-2-git-send-email-zajec5@gmail.com>
References: <1405854022-11833-1-git-send-email-zajec5@gmail.com>
	<1405854022-11833-2-git-send-email-zajec5@gmail.com>
Date: Sun, 20 Jul 2014 13:02:11 +0200
Message-ID: <CACna6rywJpbGSyFzGNBy6n46yChtHnewwyXDX2p6wz0ztt24HQ@mail.gmail.com> (sfid-20140720_131011_685127_ECDD9917)
Subject: Re: [PATCH 2/2] b43: N-PHY: support setting custom TX power
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 July 2014 13:00, Rafał Miłecki <zajec5@gmail.com> wrote:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> This is based on top of
> [PATCH 7/7] b43: enable radio 0x2057 rev 14 support (AKA BCM43217)
> (not sure if applies cleanly otherwise)

Forgot to say. I've tested this on BCM4321, BCM4322, BCM43224,
BCM43217 and BCM43228. No performance regressions observed, so I guess
my code doesn't do anything stupid ;)
