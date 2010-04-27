Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:24619 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab0D0Pin (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 11:38:43 -0400
Message-ID: <4BD70485.1070203@oracle.com>
Date: Tue, 27 Apr 2010 08:36:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux-next <linux-next@vger.kernel.org>
Subject: linux-next: April 27 (wireless/libertas warnings)
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/libertas_tf/deb_defs.h:12:1: warning: "pr_fmt" redefined
include/linux/kernel.h:376:1: warning: this is the location of the previous definition
drivers/net/wireless/libertas_tf/deb_defs.h:12:1: warning: "pr_fmt" redefined
include/linux/kernel.h:376:1: warning: this is the location of the previous definition

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
