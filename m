Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:3477 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754892AbYBORnV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 12:43:21 -0500
Subject: [PATCH 2/2] Remove MAC_FMT
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: bruno@thinktube.com, netdev@vger.kernel.org, jgarzik@pobox.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20080215.025855.202184003.davem@davemloft.net>
References: <20080215104804.9870.15722.stgit@one>
	 <20080215.025855.202184003.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 09:42:55 -0800
Message-Id: <1203097375.21308.20.camel@localhost> (sfid-20080215_174347_403400_1BFAEC3E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MAC_FMT is no longer used

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/include/linux/if_ether.h b/include/linux/if_ether.h
index e157c13..7a1e011 100644
--- a/include/linux/if_ether.h
+++ b/include/linux/if_ether.h
@@ -130,7 +130,6 @@ extern ssize_t sysfs_format_mac(char *buf, const unsigned char *addr, int len);
  *	Display a 6 byte device address (MAC) in a readable format.
  */
 extern char *print_mac(char *buf, const unsigned char *addr);
-#define MAC_FMT "%02x:%02x:%02x:%02x:%02x:%02x"
 #define MAC_BUF_SIZE	18
 #define DECLARE_MAC_BUF(var) char var[MAC_BUF_SIZE] __maybe_unused
 


