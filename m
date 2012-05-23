Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37699 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965042Ab2EWDKG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2012 23:10:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SX1xc-0008D6-Sd
	for linux-wireless@vger.kernel.org; Wed, 23 May 2012 05:10:05 +0200
Received: from c-69-245-126-173.hsd1.mi.comcast.net ([69.245.126.173])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 23 May 2012 05:10:04 +0200
Received: from ilhebe999 by c-69-245-126-173.hsd1.mi.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 23 May 2012 05:10:04 +0200
To: linux-wireless@vger.kernel.org
From: Xun Ouyang <ilhebe999@gmail.com>
Subject: wireless-testing in fedora 16
Date: Wed, 23 May 2012 03:01:51 +0000 (UTC)
Message-ID: <loom.20120523T045118-15@post.gmane.org> (sfid-20120523_051016_330547_145DB3AF)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,everybody,I am a beginner in linux and when I compiled the kernel,
"drivers/net/wireless/iwlegacy/common.c    fatal error:iwl-io.h:No such file or 
directory." there is a file named <iwl-io.h> under the fold 
drivers/net/wireless/iwlwifi. I think it is not a problem when these two 
files are in the different folds, right? since there are some other files 
contains the "#include <iwl-io.h>" and they are not in the same directory.

