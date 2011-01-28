Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wipro-blr-out01.wipro.com ([203.91.198.74]:53646 "EHLO
	wipro-blr-out02.wipro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754921Ab1A1EFl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 23:05:41 -0500
From: <raghunathan.kailasanathan@wipro.com>
To: <Larry.Finger@lwfinger.net>
CC: <linux-wireless@vger.kernel.org>
Date: Fri, 28 Jan 2011 09:35:35 +0530
Subject: RE: unable to put RTL8192SU in master mode
Message-ID: <6D6CA94E9F944C45ABD35E9F7E1CAE619BBF56D5E7@BLR-SJP-MB02.wipro.com>
References: <6D6CA94E9F944C45ABD35E9F7E1CAE619BBF56D579@BLR-SJP-MB02.wipro.com>
 <4D4183BD.3060609@lwfinger.net>
In-Reply-To: <4D4183BD.3060609@lwfinger.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: Larry Finger [mailto:larry.finger@gmail.com] On Behalf Of Larry
> Finger
> The driver from the Realtek web site is named 8712u, and the one in the
> kernel
> staging tree (2.6.37 and later) is called r8712u. Which one are you
> using? They
> are not the same.
> 

Thanks Larry. I am using the 8712u, so it should be the realtek one. I am on
a older kernel (2.6.27) hence using the staging one would require some backporting 
effort.

BTW what are the key differences between both ? 


--RK
