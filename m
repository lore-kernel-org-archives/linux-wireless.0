Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42810 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab1GWJoW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 05:44:22 -0400
Received: by qyk29 with SMTP id 29so150137qyk.19
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jul 2011 02:44:21 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110723072120.17363.56122.stgit@mj.roinet.com>
References: <20110723072113.17363.59871.stgit@mj.roinet.com>
	<20110723072120.17363.56122.stgit@mj.roinet.com>
Date: Sat, 23 Jul 2011 11:44:21 +0200
Message-ID: <CA+icZUV0sL=P57uGoM9Hc7n7w7u0C6ZP+2N8jzQ2Wz5M9MXD5Q@mail.gmail.com> (sfid-20110723_114425_166731_164AB4A0)
Subject: Re: [PATCH 2/3] ath5k: remove most references to XR
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 23, 2011 at 9:21 AM, Pavel Roskin <proski@gnu.org> wrote:
> XR is a proprietary feature of the chipset.  It's not supported and
> should not be supported.
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>
>

Tested on Atheros AR5212 chip against linux-next (next-20110722).

Feel free to add:

     Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

- Sedat -
