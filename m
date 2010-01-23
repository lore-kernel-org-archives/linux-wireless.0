Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:38088 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751877Ab0AWVxf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 16:53:35 -0500
Message-ID: <4B5B6FCA.2070900@redfish-solutions.com>
Date: Sat, 23 Jan 2010 13:53:14 -0800
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Pavel Roskin <proski@gnu.org>, Markus Baier <markus_baier@web.de>,
	linux-wireless@vger.kernel.org, kalle.valo@iki.fi
Subject: Re: Starting hostapd causes kernel panic
References: <loom.20100122T205326-794@post.gmane.org>	 <1264193623.2593.17.camel@johannes.local> <1264196526.3040.3.camel@mj>	 <3ef14e53bb12298507dbaec4bb0b98d3.squirrel@secure.sipsolutions.net>	 <1264197963.9056.0.camel@mj> <1264251576.2593.30.camel@johannes.local>
In-Reply-To: <1264251576.2593.30.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/23/2010 04:59 AM, Johannes Berg wrote:
> On Fri, 2010-01-22 at 17:06 -0500, Pavel Roskin wrote:
>   
>> On Fri, 2010-01-22 at 22:53 +0100, Johannes Berg wrote:
>>     
>>>> I assume it's another case where tx->key should be checked for being
>>>> NULL.  In fact, it's set to NULL on the preceding line!
>>>>         
>>> or an else inserted.
>>>       
>> Whatever you prefer.  Either way, the panic is fixed now!
>>     
> Great, and sorry about that! I'll send a patch to insert the else too.
>
> johannes
>   

Did you send that patch?  I'd like to apply it.  Please copy me when you send it out.

Thanks.

