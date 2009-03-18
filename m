Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:1960 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbZCRTmd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 15:42:33 -0400
Received: by yx-out-2324.google.com with SMTP id 31so207614yxl.1
        for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2009 12:42:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237272937.5622.11.camel@subratamodak.linux.ibm.com>
References: <9a14a0630903130632s36a7f059hd093d30e97f894eb@mail.gmail.com>
	 <1236962876.7439.3.camel@subratamodak.linux.ibm.com>
	 <1237272937.5622.11.camel@subratamodak.linux.ibm.com>
Date: Wed, 18 Mar 2009 12:42:30 -0700
Message-ID: <43e72e890903181242i1be5818et8afd1157cff8af83@mail.gmail.com> (sfid-20090318_204237_060172_8EA64A8B)
Subject: Re: [LTP] Support of WIFI and W-LAN test cases in LTP
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: subrata@linux.vnet.ibm.com
Cc: rahul Baliyan <rahul.lpt@gmail.com>, ltp-list@lists.sf.net,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 16, 2009 at 11:55 PM, Subrata Modak
<subrata@linux.vnet.ibm.com> wrote:
> Hi Rahul,
>
> On Fri, 2009-03-13 at 22:17 +0530, Subrata Modak wrote:
>> Hi,
>>
>> On Fri, 2009-03-13 at 19:02 +0530, rahul Baliyan wrote:
>> > Hi,
>> >
>> > Pl. =C2=A0confirm if LTP contains the test cases of W-LAN and WI-F=
I.
>>
>> Nope. We do not have till now. However, we initiated some discussion
>> some 6 months back in the same mailing list regarding Wireless Mesh
>> Netwoking tests. Please follow the following thread:
>>
>> http://marc.info/?t=3D121969812900007&r=3D1&w=3D2&n=3D4,
>>
>> There are some tests already avilable. We need somebody to volunteer=
 to
>> bring them to some shape so that they can be automated and then
>> integrated inside LTP. Would you be ready to do that ?
>
> Would you like to take up my proposal ?

BTW I've stashed a Linux wireless testing entry in the Linux
=46oundation GSoC, hopefully that can be merged back into LTP.

https://www.linuxfoundation.org/en/Google_Summer_of_Code_2009#Automatio=
n_of_testing_using_mac80211_hwsim_and_Orbit

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
