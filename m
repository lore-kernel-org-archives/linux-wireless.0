Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:34857 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbZFZL7J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2009 07:59:09 -0400
MIME-Version: 1.0
In-Reply-To: <200906261336.29318.elendil@planet.nl>
References: <200906261336.29318.elendil@planet.nl>
Date: Fri, 26 Jun 2009 13:59:10 +0200
Message-ID: <8db1092f0906260459n308311faweb6d9733cdd1eb13@mail.gmail.com>
Subject: Re: [2.6.31-rc1] iwlagn (4965): no wireless due to RFKILL problem
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/6/26 Frans Pop <elendil@planet.nl>:
> I've tried .31-rc1 on my HP 2510p notebook and the only problem I found
> was that wireless no longer works. The cause looks to be related to
> RFKILL.
>

Same on HP/Compaq nx6310, caused by hp-wmi module. It's disable
bluetooth and wireless. I must turn it on in Windows XP (in HP tools).
Workaround: don't load hp-wmi. Already I try find how enable it via
/sys like in Windows.

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
