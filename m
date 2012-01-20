Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li235-22.members.linode.com ([173.255.225.22]:36340 "EHLO
	erley.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855Ab2ATSd0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 13:33:26 -0500
Message-ID: <4F19B185.904@erley.org> (sfid-20120120_193331_028924_8A46EB25)
Date: Fri, 20 Jan 2012 13:25:09 -0500
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: Gerhard J Norkus <gnorkus@comcast.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8192CU problems with EAPOL
References: <loom.20120117T033430-62@post.gmane.org>
In-Reply-To: <loom.20120117T033430-62@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/16/2012 09:54 PM, Gerhard J Norkus wrote:
> I already have isc-dhcp-server running in the background pointing to wlan1.  I
> launch hostapd using the following command:

Have you tried starting isc-dhcp-server after hostapd?  I know in the past, hostapd
would delete and recreate the wireless interface.

Pat Erley
