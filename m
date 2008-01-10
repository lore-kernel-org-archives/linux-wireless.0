Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:29878 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbYAJVTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 16:19:07 -0500
Message-ID: <47868B31.1000705@oracle.com> (sfid-20080110_211915_989066_A18F698B)
Date: Thu, 10 Jan 2008 13:16:33 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Roel Kluin <12o3l@tiscali.nl>, linville@tuxdriver.com,
	lkml <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless/arlan] Replace logical- by bit-and
References: <4722453E.2090801@tiscali.nl>	<472248AC.7080201@tiscali.nl>	<47866EE9.80003@tiscali.nl> <20080110122859.569b3774.randy.dunlap@oracle.com> <4786849D.4010504@redhat.com>
In-Reply-To: <4786849D.4010504@redhat.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chuck Ebbert wrote:
> On 01/10/2008 03:28 PM, Randy Dunlap wrote:

>>
>> 0x80 && 0x40 -> 0
> 
> 1

duh.  ack.

-- 
~Randy
