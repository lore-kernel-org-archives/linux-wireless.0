Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:37984 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752094AbYJ1D7x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 23:59:53 -0400
Received: from localhost (mail.kroah.net [66.93.40.174])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by coco.kroah.org (Postfix) with ESMTPSA id 0C04A47C8C
	for <linux-wireless@vger.kernel.org>; Mon, 27 Oct 2008 20:59:52 -0700 (PDT)
Date: Mon, 27 Oct 2008 20:57:24 -0700
From: Greg KH <greg@kroah.com>
To: linux-wireless@vger.kernel.org
Subject: agnx driver was just added to the staging tree
Message-ID: <20081028035724.GA17726@kroah.com> (sfid-20081028_045957_156512_1A3F58B4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just a short note to everyone, I've added the agnx driver to my staging
tree, so it should be on a short path to mainline.  The driver doesn't
look that bad at all, and doesn't add a whole new wireless stack within
it like some of the other staging wireless drivers :)

thanks,

greg k-h
