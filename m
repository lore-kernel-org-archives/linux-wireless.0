Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from leit.jelmoni.net ([78.46.129.73]:49606 "EHLO leit.jelmoni.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab2DTUxS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 16:53:18 -0400
Received: from localhost (localhost.jelmoni.net [127.0.0.1])
	by leit.jelmoni.net (Postfix) with ESMTP id D37E580CF
	for <linux-wireless@vger.kernel.org>; Fri, 20 Apr 2012 22:43:55 +0200 (CEST)
Received: from leit.jelmoni.net ([127.0.0.1])
	by localhost (leit.jelmoni.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Fi1U4ELnu+Ge for <linux-wireless@vger.kernel.org>;
	Fri, 20 Apr 2012 22:43:55 +0200 (CEST)
Received: from laptop-beat.swiss-wireless.com.ar (host188.190-229-196.telecom.net.ar [190.229.196.188])
	(Authenticated sender: genauth@swiss-wireless.com.ar)
	by leit.jelmoni.net (Postfix) with ESMTPSA id 12B7480CE
	for <linux-wireless@vger.kernel.org>; Fri, 20 Apr 2012 22:43:54 +0200 (CEST)
Message-ID: <4F91CA71.4040703@swiss-wireless.com.ar> (sfid-20120420_225322_587827_6849C87E)
Date: Fri, 20 Apr 2012 17:43:29 -0300
From: Beat Meier <mbe_ml@swiss-wireless.com.ar>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: How can I read distance settings from physical device?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

How can I get the distance settings from a physical device?
I can set it with
   iw phy phy0 set distance 3500
but how can I read it?

Thanks

Beat
