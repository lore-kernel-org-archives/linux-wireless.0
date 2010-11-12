Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:55324 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817Ab0KLRkt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 12:40:49 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PGxcF-0005yV-KR
	for linux-wireless@vger.kernel.org; Fri, 12 Nov 2010 18:40:47 +0100
Received: from function.justgohome.co.uk ([217.169.15.243])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 18:40:47 +0100
Received: from rb-oss-3 by function.justgohome.co.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 18:40:47 +0100
To: linux-wireless@vger.kernel.org
From: Robie Basak <rb-oss-3@justgohome.co.uk>
Subject: Re: r8187se panic
Date: Fri, 12 Nov 2010 17:40:36 +0000 (UTC)
Message-ID: <slrnidqv0k.g21.rb-oss-3@mal.justgohome.co.uk>
References: <slrnidp3ae.79c.rb-oss-3@mal.justgohome.co.uk>
 <4CDC9FA5.10002@lwfinger.net>
 <slrnidq7u0.9ic.rb-oss-3@mal.justgohome.co.uk>
 <4CDD3BC4.7070102@lwfinger.net>
 <slrnidqorp.dlr.rb-oss-3@mal.justgohome.co.uk>
 <4CDD66C4.10603@lwfinger.net>
 <slrnidqsld.dlr.rb-oss-3@mal.justgohome.co.uk>
 <4CDD7945.70005@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-12, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> What does the following log entry signify?
>
> Nov 12 16:29:03 tiny kernel: [  160.306731]
>=>>>>>>>>>>=============================>set power:0,0!
>
> On my system, switching to battery does not affect the rtl8187se at all.

That is consistently showing up every time I switch from AC to battery
(but not battery to AC) while wireless is on. It does not appear if I
turn the wireless off, disconnect AC and then turn wireless on again.

Also for a suspend/resume cycle, it appears only if on battery and
wireless is on.

Robie

