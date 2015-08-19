Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:33091 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbbHSDPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 23:15:12 -0400
From: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCHv4 0/2] staging: wilc1000: code improvements
Date: Tue, 18 Aug 2015 23:14:48 -0400
Message-Id: <cover.1439953865.git.raphael.beamonte@gmail.com> (sfid-20150819_051627_006693_8EC95399)
In-Reply-To: <20150819025942.GD4588@kroah.com>
References: <20150819025942.GD4588@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

As requested, here are the two remaining ready patches of this
patchset. I pulled and rebased against staging-testing just now.
They should thus be usable without problem!

Thanks,
Raphaël


Raphaël Beamonte (2):
  staging: wilc1000: remove FREE_WILC_BUFFER()
  staging: wilc1000: replace MALLOC_WILC_BUFFER() macro to avoid
    possible memory leak

 drivers/staging/wilc1000/wilc_exported_buf.c | 40 +++++++++++++++++-----------
 1 file changed, 24 insertions(+), 16 deletions(-)

-- 
2.1.4

