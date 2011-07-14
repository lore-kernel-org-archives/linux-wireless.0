Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:30705 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437Ab1GNXSw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 19:18:52 -0400
Message-ID: <4E1F795A.2090808@gnu.org> (sfid-20110715_011856_040079_705BC3F5)
Date: Thu, 14 Jul 2011 19:18:50 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] hostap: remove IDs for 3Com AirConnect PCI 777A, it uses
 Symbol firmware
References: <20110714223730.23239.44416.stgit@mj.roinet.com>
In-Reply-To: <20110714223730.23239.44416.stgit@mj.roinet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/14/2011 06:37 PM, Pavel Roskin wrote:
> hostap only supports Intersil firmware.  Symbol firmware is supported by
> orinoco.

Sorry, the patch is wrong.  I misinterpreted a bug report.  Several 
webpages indicate that 3CRWE777A actually uses Intersil firmware.

http://www.wikidevi.com/wiki/3Com_AirConnect_3CRWE777A
http://www.linuxquestions.org/questions/linux-networking-3/redhat-9-0-3com-airconnect-3crwe777a-114501/
http://gothmog.homeunix.net/blog/?p=78

Sorry for the noise :(

-- 
Regards,
Pavel Roskin
