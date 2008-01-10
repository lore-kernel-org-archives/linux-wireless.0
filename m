Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4660 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbYAJVv0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 16:51:26 -0500
Date: Thu, 10 Jan 2008 16:28:53 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, Roel Kluin <12o3l@tiscali.nl>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless/arlan] Replace logical- by bit-and
Message-ID: <20080110212853.GH3109@tuxdriver.com> (sfid-20080110_215130_034384_C724E604)
References: <4722453E.2090801@tiscali.nl> <472248AC.7080201@tiscali.nl> <47866EE9.80003@tiscali.nl> <20080110122859.569b3774.randy.dunlap@oracle.com> <4786849D.4010504@redhat.com> <47868B31.1000705@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <47868B31.1000705@oracle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 10, 2008 at 01:16:33PM -0800, Randy Dunlap wrote:
> Chuck Ebbert wrote:
>> On 01/10/2008 03:28 PM, Randy Dunlap wrote:
>
>>>
>>> 0x80 && 0x40 -> 0
>>
>> 1
>
> duh.  ack.

Well it still seems wrong, changing from an "| 1" to an "| 0".
Anyone still using Arlan that can verify the proper fix (which I'd
guess is changing "&&" to "|")?

John
-- 
John W. Linville
linville@tuxdriver.com
