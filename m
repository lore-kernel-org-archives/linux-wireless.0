Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36328 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab0J3G30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Oct 2010 02:29:26 -0400
MIME-Version: 1.0
In-Reply-To: <20101030031503.GB24188@vigoh>
References: <20101030031503.GB24188@vigoh>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 29 Oct 2010 23:29:05 -0700
Message-ID: <AANLkTimyNLEsrNcUF3LfBR7_Rj+gKZzvbaU5Yxw1RnY-@mail.gmail.com>
Subject: Re: pull request: bluetooth-2.6 2010-10-30
To: "Gustavo F. Padovan" <padovan@profusion.mobi>,
	Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linville@tuxdriver.com, linux-bluetooth@vger.kernel.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 29, 2010 at 8:15 PM, Gustavo F. Padovan
<padovan@profusion.mobi> wrote:
> Hi John,
>
> The following batch contains some bugfixes for 2.6.37. A fix for unaligned
> access in L2CAP, a Kconfig error, and two fixes related to security of
> the Bluetooth links. There is also a one line patch from Matthew Garret,
> that enables USB autosuspend for btusb module, which shall be completely
> safe. Please pull, thanks.

> Matthew Garrett (1):
>      Bluetooth: Enable USB autosuspend by default on btusb

BTW, is this the thing that powertop nags about?

  Luis
