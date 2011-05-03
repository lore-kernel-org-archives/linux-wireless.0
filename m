Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f170.google.com ([209.85.212.170]:35729 "EHLO
	mail-px0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab1ECUdi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 16:33:38 -0400
Message-ID: <4DC0669E.4040100@lwfinger.net> (sfid-20110503_223359_731091_B2CD5FAB)
Date: Tue, 03 May 2011 15:33:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Walter Goldens <goldenstranger@yahoo.com>,
	John W Linville <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	chaoming_li@realsil.com.cn
Subject: Re: [PATCH 00/12] rtlwifi: rtl8192se: Merge new driver
References: <776913.88107.qm@web161609.mail.bf1.yahoo.com> <4DC0312A.4040303@lwfinger.net> <BANLkTinw+jv8zBi29EKs2K2=tAJMYCEdgQ@mail.gmail.com>
In-Reply-To: <BANLkTinw+jv8zBi29EKs2K2=tAJMYCEdgQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/03/2011 03:19 PM, Gábor Stefanik wrote:
> On Tue, May 3, 2011 at 6:45 PM, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>> On 05/03/2011 10:59 AM, Walter Goldens wrote:
>>>
>>>> This set of patches introduces a driver for the RTL8192SE PCI devices.
>>>
>>> Any estimates on the *SU driver? :)
>>
>> Now that rtl8192se is submitted, I will start work on the driver for the
>> RTL8192DE devices. After that will be the RTL8191SU. It has lower priority
>> because r8712u from staging handles those devices. It is not based on
>> mac80211, but it works.
>
> Again, may I remind you that the preferred behavior in the Linux world
> is release-early, release-often? :-)

That I know, but "code first" still applies. If the comparison between rtl8192ce 
and rtl8192cu has any validity for the rtl8192s varieties, roughly half of this 
driver will be shared. In addition, we do have all the USB plumbing in place, 
but we are still talking about a few thousand lines of code. At last contact, 
Realtek has no interest in this project, thus I will be on my own.

Larry


