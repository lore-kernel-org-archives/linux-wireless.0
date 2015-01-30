Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:50392 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762644AbbA3PQU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 10:16:20 -0500
Received: by mail-oi0-f49.google.com with SMTP id a3so34973564oib.8
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 07:16:19 -0800 (PST)
Date: Fri, 30 Jan 2015 09:16:05 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org
Subject: [ANN] wireless-regdb: master-2015-01-30
Message-ID: <20150130151605.GD124346@ubuntu-hedt> (sfid-20150130_161623_162711_26909D9A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A new release of wireless-regdb (master-2015-01-30) is available at:

https://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-2015.01.30.tar.gz

Note that this is the first release signed with my key. As of yet there
is no release of CRDA which by default trusts a regulatory.bin signed
with my key, but in most cases it will still trust regulatory.bin by
virtue of having the corresponding public key installed in e.g.
/lib/crda/pubkeys.

The short log of changes included since the 2014-11-18 release is below.

Seth

---

Daiwei Li (1):
      wireless-regdb: Add back regulatory rules for US

Jouni Malinen (4):
      wireless-regdb: Disable VHT80 where 40/80 MHz on 5 GHz is not allowed
      wireless-regdb: Add regulatory rules for Nigeria (NG)
      wireless-regdb: Add regulatory rules for Samoa (WS)
      wireless-regdb: Add regulatory rules for Tanzania (TZ)

Seth Forshee (2):
      wireless-regdb: Update keys and maintainer information
      wireless-regdb: update regulatory.bin based on preceding changes

