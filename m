Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40552 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758101Ab2DYGHf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 02:07:35 -0400
Received: by wejx9 with SMTP id x9so885567wej.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2012 23:07:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOvK7nCwRbDNZSnn0EvFMpcQMvX1DmU-tBuFT4kRW1TigwyJDQ@mail.gmail.com>
References: <CAOvK7nAOHqKC8rpFDqGnW7NLCX-G2+syRGih_rv7N5O5rfOUdA@mail.gmail.com>
	<CANUX_P1t8XJOka-QGzZSYFHb6MLc7rm4madn059Yg4b6hJB49A@mail.gmail.com>
	<CAOvK7nDO4fS6R5go+ZXYBqyQc8hhbJGun9Weh=-EyX5k11+tXw@mail.gmail.com>
	<CANUX_P2rzvDCBVLmU2rfaZmUOCMuMDe5=TXE_jwxq4ULrvc=QQ@mail.gmail.com>
	<CAOvK7nCwRbDNZSnn0EvFMpcQMvX1DmU-tBuFT4kRW1TigwyJDQ@mail.gmail.com>
Date: Wed, 25 Apr 2012 09:07:33 +0300
Message-ID: <CANUX_P0JsyA53T_vs5Ea0pE5Ye4G9xRC4xKcdwgAmoC8E63sHg@mail.gmail.com> (sfid-20120425_080808_086575_584A5663)
Subject: Re: iwlwifi bug
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: dchyan@princeton.edu
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 25, 2012 at 08:58, Daniel Chyan <dchyan@princeton.edu> wrote:
> Correct me if I did it incorrectly. I issue "sudo modprobe iwlwifi
> debug=0x80000000" but I receive an "Unknown symbol in module, or
> unknown parameter" error.
>

All right, please compile with CONFIG_IWLWIFI_DEBUG=y
