Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35509 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3EBHZT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 03:25:19 -0400
Message-ID: <1367479511.8298.0.camel@jlt4.sipsolutions.net> (sfid-20130502_092522_799833_61BC975B)
Subject: Re: iw: BUG:  Lists more than one phy in info request.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 02 May 2013 09:25:11 +0200
In-Reply-To: <5181ACA0.808@candelatech.com> (sfid-20130502_020047_306084_9B21A3B6)
References: <5181ACA0.808@candelatech.com>
	 (sfid-20130502_020047_306084_9B21A3B6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-05-01 at 17:00 -0700, Ben Greear wrote:
> When running this command on a system with two wiphy devices
> (renamed from phy0, phy1), the command below dumps info for
> both wiphy0 and wiphy1
> 
> iw phy wiphy1 info
> 
> iw version is latest from git.
> 
> kernel is 3.9.0+
> 
> Using the 'standard' iw on Fedora 14 (version 0.9.22)
> it behaves as I expected and only dumps info for wiphy1.

Thanks, fixed.

johannes

