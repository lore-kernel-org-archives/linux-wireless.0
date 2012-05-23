Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43292 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab2EWU6M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 16:58:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SXIdG-0005xm-Br
	for linux-wireless@vger.kernel.org; Wed, 23 May 2012 22:58:10 +0200
Received: from 141.215.239.88 ([141.215.239.88])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 23 May 2012 22:58:10 +0200
Received: from ilhebe999 by 141.215.239.88 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 23 May 2012 22:58:10 +0200
To: linux-wireless@vger.kernel.org
From: Ouyang <ilhebe999@gmail.com>
Subject: fatal error:iwl-io.h:No such file or directory
Date: Wed, 23 May 2012 20:57:56 +0000 (UTC)
Message-ID: <loom.20120523T225321-807@post.gmane.org> (sfid-20120523_225815_774679_4D20620E)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

compiled the kernel,"drivers/net/wireless/iwlegacy/common.c fatal error:iwl-
io.h:No such file or directory." there is a file named <iwl-io.h> under 
the fold drivers/net/wireless/iwlwifi. since there are some other files
contains the "#include <iwl-io.h>" and they are not in the same directory.then 
what cause the error?

