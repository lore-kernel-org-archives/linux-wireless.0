Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:2895 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920Ab0EITXM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 May 2010 15:23:12 -0400
Message-ID: <4BE70B9E.2070902@gmail.com>
Date: Sun, 09 May 2010 21:23:10 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Adam Baker <linux@baker-net.org.uk>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 6/9] rt2x00: Clean up generic procedures on descriptor
 writing.
References: <1273354826-4335-1-git-send-email-gwingerde@gmail.com> <1273354826-4335-7-git-send-email-gwingerde@gmail.com> <loom.20100509T205352-131@post.gmane.org>
In-Reply-To: <loom.20100509T205352-131@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/09/10 20:54, Adam Baker wrote:
> Gertjan van Wingerde <gwingerde@...> writes:
> 
>> -	 *	3) Rule 2 can be broken when the available entries
>> +	 *	2) Rule 2 can be broken when the available entries
>>  	 *	   in the queue are less then a certain threshold.
>>  	 */
> 
> shouldn't this say Rule 1 can be broken now?
> 

Yes, you're right. Update of the patch is on its way.

---
Gertjan
