Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:54150 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757790AbXEVTwc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2007 15:52:32 -0400
Message-ID: <46533683.2030304@linux.intel.com>
Date: Tue, 22 May 2007 11:29:23 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
References: <464B7B7C.5080800@linux.intel.com> <20070516182700.912a21ed.randy.dunlap@oracle.com> <464DF7FC.5070702@linux.intel.com> <20070518140619.a7e30a56.randy.dunlap@oracle.com> <20070522183956.GB5993@tuxdriver.com>
In-Reply-To: <20070522183956.GB5993@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Fri, May 18, 2007 at 02:06:19PM -0700, Randy Dunlap wrote:
>> On Fri, 18 May 2007 12:01:16 -0700 James Ketrenos wrote:
>>
>>> Randy Dunlap wrote:
>>>>> 	http://intellinuxwireless.org/iwlwifi/0001-Add-iwlwifi-wireless-drivers.patch
>>>> Some comments/review, mostly not-code-related:
>>>>
>>> Here is the current status (everything not described below has been fixed in GIT, and is available in the patch at http://intellinuxwireless.org/iwlwifi/0001-v2-Add-iwlwifi-wireless-drivers.patch:
>>>
>> [specific updates clipped]
>>
>>> Are you OK with iwlwifi addressing the above post-merge into wireless-dev?
>> /me points to Mr. Linville.  :)
> 
> I'm happy to take it into wireless-dev at this point.
> 
> James, will you be posting an updated patch?

Yes.  I'm testing the code w/ the bitfield usage removed and finishing up a few of the items from Michael's list.  By end of day today I hope to have an updated patch for you.

Thanks,
James
