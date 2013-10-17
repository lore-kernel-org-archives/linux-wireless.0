Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:53448 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478Ab3JQObn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 10:31:43 -0400
Received: by mail-ie0-f179.google.com with SMTP id aq17so4010475iec.38
        for <linux-wireless@vger.kernel.org>; Thu, 17 Oct 2013 07:31:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
References: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
Date: Thu, 17 Oct 2013 16:31:42 +0200
Message-ID: <CAGXE3d_HZZrEspONsjoqGrynGKYN9pisX-jgRZdV760uuVq5cQ@mail.gmail.com> (sfid-20131017_163147_169004_0F355D78)
Subject: Re: [PATCH 00/21] rt2x00: separate rt2800 PCI and SoC driver
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 17, 2013 at 9:42 AM, Gabor Juhos <juhosg@openwrt.org> wrote:
> The rt2800pci driver supports both PCI and SoC device. To achieve
> this, the code uses several ifdef statements which makes the code
> quite ugly. The patch set introduces a shared module, and moves the
> SoC driver into a separate module to get rid of the mess.

Nice series. Does this also reduce module size on when building for
SoC without PCI support?
Helmut
