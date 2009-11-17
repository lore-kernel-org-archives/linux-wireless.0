Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:44199 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbZKQOMZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 09:12:25 -0500
Received: by fg-out-1718.google.com with SMTP id d23so1738783fga.1
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2009 06:12:30 -0800 (PST)
Message-ID: <4B02AF4A.50705@lwfinger.net>
Date: Tue, 17 Nov 2009 08:12:26 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: 2.6.32-rc7-git1: Reported regressions 2.6.30 -> 2.6.31	(wireless)
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera> <20091117135308.GB27743@tuxdriver.com>
In-Reply-To: <20091117135308.GB27743@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/17/2009 07:53 AM, John W. Linville wrote:
> On Mon, Nov 16, 2009 at 11:58:32PM +0100, Rafael J. Wysocki wrote:
>> This message contains a list of some regressions introduced between 2.6.30 and
>> 2.6.31, for which there are no fixes in the mainline I know of.  If any of them
>> have been fixed already, please let me know.
> 
>> Unresolved regressions
>> ----------------------

>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14181
>> Subject		: b43 causes panic at ifconfig down / shutdown
>> Submitter	: Jeremy Huddleston <jeremyhu@freedesktop.org>
>> Date		: 2009-09-15 18:34 (63 days old)

This one is fixed by commit d50bae33d1358b909ade05ae121d83d3a60ab63f in
mainline. The patch was also sent to stable. Rafael has marked it CLOSED.

Larry


