Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from st11p02mm-asmtp002.mac.com ([17.172.220.237]:47078 "EHLO
	st11p02mm-asmtp002.mac.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755350Ab2KHMeH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 07:34:07 -0500
MIME-version: 1.0
Content-type: text/plain; CHARSET=US-ASCII
Received: from [192.168.1.3]
 (pd284a7bb.kngwnt01.ap.so-net.ne.jp [210.132.167.187])
 by st11p02mm-asmtp002.mac.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Jan
  3 2012)) with ESMTPSA id <0MD6000V42SN9C90@st11p02mm-asmtp002.mac.com> for
 linux-wireless@vger.kernel.org; Thu, 08 Nov 2012 11:34:03 +0000 (GMT)
Subject: Re: "mac80211.ko" and "cfg80211.ko" compatibility issue.
From: Nonaka Akira <nonaka@mac.com>
In-reply-to: <CAGRGNgUB_7NZTnC2k2_f0_bAP0yu4cXTqk3_QpxpKZHqw__+hw@mail.gmail.com>
Date: Thu, 08 Nov 2012 20:33:58 +0900
Message-id: <9983E05C-2103-49C8-A675-4F5368F53FB5@mac.com> (sfid-20121108_133420_491963_9D90FBDE)
References: <509B73D5.5000206@mac.com>
 <CAGRGNgUB_7NZTnC2k2_f0_bAP0yu4cXTqk3_QpxpKZHqw__+hw@mail.gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

Well, We consider the option of using the entire compat-wireless drivers. However, we are planning the minor update of our product toward the end of the year and I thought it will be nice if I can keep the change minimum.

--
Nonaka Akira

On 2012/11/08, at 20:16, Julian Calaby wrote:

> Hi,
> 
> On Thu, Nov 8, 2012 at 7:56 PM, Akira Nonaka <nonaka@mac.com> wrote:
>> Hi all,
>> 
>> I have a problem with the compat-wireless. It seems "mac80211.ko" and
>> "cfg80211.ko" are not compatible with the ones in main line kernel. In
>> my case, it is kernel 3.4.9(Fedora 16).
> 
> This is expected and pretty much by design.
> 
>> I want to use  compat-wireless version of "mac80211.ko" and
>> "cfg80211.ko" for Realtek rtl8723ae but for other wireless cards, I want
>> to use main line kernel version of "mac80211.ko" and "cfg80211.ko".
> 
> Why? Are the drivers for these other cards not available in compat-wireless?
> 
> Thanks,
> 
> -- 
> Julian Calaby
> 
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/
> .Plan: http://sites.google.com/site/juliancalaby/

