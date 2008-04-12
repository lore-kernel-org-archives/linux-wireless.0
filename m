Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.fenrir.org.uk ([81.168.115.223]:33024 "EHLO mx.fenrir.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756957AbYDLAXI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2008 20:23:08 -0400
Received: from fangio.fenrir.org.uk ([10.0.0.4])
	(TLSv1:AES256-SHA:256)
	by mx.fenrir.org.uk with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1JkTWL-00011c-M2
	for <linux-wireless@vger.kernel.org>; Sat, 12 Apr 2008 01:23:05 +0100
Date: Sat, 12 Apr 2008 01:23:05 +0100
From: Brian Morrison <bdm@fenrir.org.uk>
To: linux-wireless@vger.kernel.org
Subject: Latest compat-wireless build fails
Message-ID: <20080412012305.76f1b7eb@fangio.fenrir.org.uk> (sfid-20080412_012314_710323_0A9EF5C5)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If anyone is interested, the latest compat-wireless tarball fails to
build. It complains about some missing led defines in the rt2x00
directory.

I don't have the exact error messages to hand, but I imagine it's
trivial for someone to type make and find out.

Cheers!

-- 

Brian
