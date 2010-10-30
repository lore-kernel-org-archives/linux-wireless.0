Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:47692 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab0J3CMc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 22:12:32 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PC0vk-0006qW-EO
	for linux-wireless@vger.kernel.org; Sat, 30 Oct 2010 04:12:28 +0200
Received: from CPE0014bf4aedf8-CM00111ae2cca2.cpe.net.cable.rogers.com ([173.34.126.150])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 30 Oct 2010 04:12:28 +0200
Received: from senada by CPE0014bf4aedf8-CM00111ae2cca2.cpe.net.cable.rogers.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 30 Oct 2010 04:12:28 +0200
To: linux-wireless@vger.kernel.org
From: seno <senada@t-online.de>
Subject: Re: [PATCH] rtl8187b: do not do per packet TX AGC
Date: Sat, 30 Oct 2010 02:12:17 +0000 (UTC)
Message-ID: <loom.20101030T035315-813@post.gmane.org>
References: <1282974868-22237-1-git-send-email-cascardo@holoscopio.com> <4C798080.8010002@lwfinger.net> <20100830141218.GB30864@tuxdriver.com> <4C7BC4D9.1010108@lwfinger.net> <20100830152841.GB2950@barata.holoscopio.com> <loom.20101026T200014-691@post.gmane.org> <4CC71CFF.8050004@lwfinger.net> <20101026185341.GA4608@barata.holoscopio.com> <20101028191305.2960c83b@gotham.conectiva> <loom.20101029T010426-834@post.gmane.org> <20101029135449.GB3768@barata.holoscopio.com> <loom.20101030T001241-932@post.gmane.org> <4CCB601A.9010909@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@...> writes:

> Is your device overheating?

I don't think so.

I reduced Tx-Power to 20 dBm (wireless regulatory domain DE).
That doesn't make any difference to 27 dBm (CA) or even 30 dBm (BO).
(Beside that: it performs fine in w7)

In contrast to the unchanged measured performance, web browsing feels 'snappier'
with the patched driver (websites load faster although speed peek never top > 140
kByte/s)

