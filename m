Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tdb.com ([216.99.214.4]:39745 "HELO mail.tdb.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755632Ab1EaRha (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 13:37:30 -0400
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] kernel panic on MIPS + ath5k + Wistron CM9 radio
References: <861v0igqhn.fsf@coulee.tdb.com> <86iptq8r8w.fsf@coulee.tdb.com>
	<4DC1671C.9040906@openwrt.org> <86liyjjo0a.fsf@coulee.tdb.com>
From: Russell Senior <russell@personaltelco.net>
Date: Tue, 31 May 2011 10:30:47 -0700
In-Reply-To: <86liyjjo0a.fsf@coulee.tdb.com> (Russell Senior's message of "Fri\, 06 May 2011 18\:30\:29 -0700")
Message-ID: <86ipsqkcag.fsf@coulee.tdb.com> (sfid-20110531_193733_119424_7849D408)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>>>> "Russell" == Russell Senior <seniorr@aracnet.com> writes:

Russell> I just confirmed Peizhao Hu's observation.  The CM9's with
Russell> chips marked AR5213A-001 panic on MIPS.  CM9's with chips
Russell> marked AR5213A-00 do not.  It looks like (from my small
Russell> sample immediately at hand) the stock radios on Netgear
Russell> WGT634U also are marked AR5213A-00, and don't seem to panic.

Seems to be fixed in OpenWrt r27024.  Thanks Felix!

  https://dev.openwrt.org/changeset/27024/


-- 
Russell Senior, President
russell@personaltelco.net
