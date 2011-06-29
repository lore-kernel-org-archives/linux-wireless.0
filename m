Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:48219 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757714Ab1F2Umb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 16:42:31 -0400
Message-ID: <4E0B8E35.8080203@gnu.org> (sfid-20110629_224233_699213_6E907D27)
Date: Wed, 29 Jun 2011 16:42:29 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Omar Abraham <omar.abraham@upr.edu>
CC: Alex <alex9434@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Compile error in carl9170 on Debian Squeeze
References: <BANLkTimsGJo61eLp3NrVtDkh0m3CN3zDxw@mail.gmail.com> <4E0B8A61.8090600@upr.edu>
In-Reply-To: <4E0B8A61.8090600@upr.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/29/2011 04:26 PM, Omar Abraham wrote:
> You are using older kernel headers, most likely that could be the problem

No, Debian backports netdev_name in 2.6.32.  The fix is to define 
netdev_name as a macro in compat-wireless.  The same issue was already 
reported today, and I'm about to send a patch.

-- 
Regards,
Pavel Roskin
