Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53236 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab1ECQpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 12:45:36 -0400
Message-ID: <4DC0312A.4040303@lwfinger.net> (sfid-20110503_184552_454342_834273D7)
Date: Tue, 03 May 2011 11:45:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Walter Goldens <goldenstranger@yahoo.com>
CC: John W Linville <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	chaoming_li@realsil.com.cn
Subject: Re: [PATCH 00/12] rtlwifi: rtl8192se: Merge new driver
References: <776913.88107.qm@web161609.mail.bf1.yahoo.com>
In-Reply-To: <776913.88107.qm@web161609.mail.bf1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/03/2011 10:59 AM, Walter Goldens wrote:
>
>> This set of patches introduces a driver for the RTL8192SE PCI devices.
>
> Any estimates on the *SU driver? :)

Now that rtl8192se is submitted, I will start work on the driver for the 
RTL8192DE devices. After that will be the RTL8191SU. It has lower priority 
because r8712u from staging handles those devices. It is not based on mac80211, 
but it works.

Larry
