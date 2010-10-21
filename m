Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45842 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758635Ab0JUPZt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 11:25:49 -0400
Received: from compute1.internal (compute1.nyi.mail.srv.osa [10.202.2.41])
	by gateway1.messagingengine.com (Postfix) with ESMTP id F035D2F6
	for <linux-wireless@vger.kernel.org>; Thu, 21 Oct 2010 11:25:48 -0400 (EDT)
Received: from [192.168.7.102] (64-13-95-51.mfd.clearwire-dns.net [64.13.95.51])
	by mail.messagingengine.com (Postfix) with ESMTPSA id 581CC5E1457
	for <linux-wireless@vger.kernel.org>; Thu, 21 Oct 2010 11:25:46 -0400 (EDT)
Message-ID: <4CC05B77.2070706@grojguys.com>
Date: Thu, 21 Oct 2010 08:25:43 -0700
From: m.linuxwireless@grojguys.com
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: A minor correction to the compat-wireless intructions...
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Could I suggest a minor update to the instructions at 
http://linuxwireless.org/en/users/Download,  to avoid a bit of confusion?

For whatever reason, section "9. Selecting your driver" is listed 
_before_ the instructions to extract the compat-wireless tarball in 
"Section 10. Building and installing"

(Of course, selecting a specific driver can only be done _after_ 
extracting the tarball because ./scripts/driver-select is _in_ the tarball!)

No offense or anything, but the order there seems a bit strange.  It 
threw me off the first time, so perhaps it has others as well?

On the whole though, thanks for providing the great package!

