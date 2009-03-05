Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.190]:63178 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbZCEQTJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 11:19:09 -0500
Received: by ti-out-0910.google.com with SMTP id d10so766tib.23
        for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 08:19:06 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18863.64330.683644.463962@gargle.gargle.HOWL> (sfid-20090305_171913_855910_DD9CDDEA)
Date: Thu, 5 Mar 2009 21:48:18 +0530
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [ath9k-devel] [PATCH] ath9k: create a common debugfs_root for all
	device instances
In-Reply-To: <1236268518-31873-1-git-send-email-juhosg@openwrt.org>
References: <1236268518-31873-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos wrote:
> The driver are trying to create an 'ath9k' directory in debugfs for each
> device currently. If there are more than one device in the system, the
> second try will always fail.

Looks good. Thanks.

Also, reading 'rcstat' when the interface is down would cause a NULL
pointer dereference. Will send out a patch fixing this.

Sujith

