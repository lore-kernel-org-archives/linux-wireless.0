Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:38384 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab0LWSMc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Dec 2010 13:12:32 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PVpeO-0007z9-32
	for linux-wireless@vger.kernel.org; Thu, 23 Dec 2010 19:12:28 +0100
Received: from ool-4a5955a5.dyn.optonline.net ([74.89.85.165])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 23 Dec 2010 19:12:28 +0100
Received: from erappleman by ool-4a5955a5.dyn.optonline.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 23 Dec 2010 19:12:28 +0100
To: linux-wireless@vger.kernel.org
From: Eric Appleman <erappleman@gmail.com>
Subject: Re: iwlwifi: Intel 3945ABG speed issues finally identified.
Date: Thu, 23 Dec 2010 18:12:14 +0000 (UTC)
Message-ID: <loom.20101223T190559-612@post.gmane.org>
References: <loom.20101223T071403-99@post.gmane.org> <1293120787.3997.50.camel@wwguy-huron>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have not tried testing the commits individually since kernel compilation is a
pain for me.

If I can trick a compat-wireless tree into a code splice, maybe I can test each
commit.

Do you guys know any tricks to compile iwlwifi individually?

However, I can say with utmost certainty that the regression is in the window
between rc2 and rc3 unless the Ubuntu daily kernels were mislabeled.

