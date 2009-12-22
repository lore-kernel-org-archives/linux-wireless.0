Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hogsmeade.leitwerk.net ([217.28.96.50]:37911 "EHLO
	hogsmeade.leitwerk.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZLVIoN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 03:44:13 -0500
Received: from hogsmeade.lieberbiber.de (localhost [127.0.0.1])
	by hogsmeade.leitwerk.net (Postfix) with ESMTPSA id 2FDF0A89BE
	for <linux-wireless@vger.kernel.org>; Tue, 22 Dec 2009 09:33:34 +0100 (CET)
From: Simon Raffeiner <sraffein@stud.fh-offenburg.de>
To: linux-wireless@vger.kernel.org
Subject: Re: o11s: Modularize Path Selection Protocol etc.
Date: Tue, 22 Dec 2009 09:33:33 +0100
References: <4B2F9930.8070401@cosetrain.com> <7057634E-E560-413E-9FB2-163F5311E054@gmail.com>
In-Reply-To: <7057634E-E560-413E-9FB2-163F5311E054@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200912220933.33777.sraffein@stud.fh-offenburg.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 21. Dezember 2009 17:17:29 schrieb Rui Paulo:

> This has changed quite a bit on the latest 802.11s draft standards. If you want to use your own routing protocol and to be 802.11s compliant, you need to set the path selection protocol ID to 255 and append a vendor specific information element to the management frame.

Great, so this changed again.

Is there a legal way to obtain Draft 4.0 without being a member of the 802.11 TGs? I have full access to the IEEE standards library via my university, but only Draft 3.0 has been published so far.

-- 

mit freundlichen Grüßen/regards
Simon Raffeiner

University of Applied Sciences Offenburg, Germany
Department of Computer Science, RoboCup Team
