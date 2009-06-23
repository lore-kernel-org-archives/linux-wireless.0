Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f193.google.com ([209.85.221.193]:58950 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512AbZFWWQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 18:16:40 -0400
Received: by qyk31 with SMTP id 31so526180qyk.33
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jun 2009 15:16:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890906230831q6e6c9e2v49454ab66ca99156@mail.gmail.com>
References: <9a14a0630903130632s36a7f059hd093d30e97f894eb@mail.gmail.com>
	 <1236962876.7439.3.camel@subratamodak.linux.ibm.com>
	 <1237272937.5622.11.camel@subratamodak.linux.ibm.com>
	 <43e72e890903181242i1be5818et8afd1157cff8af83@mail.gmail.com>
	 <1237446038.5260.9.camel@subratamodak.linux.ibm.com>
	 <1245768529.4860.61.camel@subratamodak.linux.ibm.com>
	 <43e72e890906230831q6e6c9e2v49454ab66ca99156@mail.gmail.com>
Date: Tue, 23 Jun 2009 19:08:43 -0300
Message-ID: <ee8eb53d0906231508ta738039m562dee936319624c@mail.gmail.com>
Subject: Re: [LTP] Support of WIFI and W-LAN test cases in LTP
From: Georgy Berdyshev <codingmaster@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: subrata@linux.vnet.ibm.com, ltp-list@lists.sf.net,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	rahul Baliyan <rahul.lpt@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Luis did already mention that the idea is to contribute things back to
LTP or have LTP use it.
In case that there is some work going on, I would like to merge those
tests also into my project
and later on extend the work with LTP.

In any case, feel free to contact me.

Regards, Georgy

On Tue, Jun 23, 2009 at 12:31 PM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:
> On Tue, Jun 23, 2009 at 7:48 AM, Subrata
> Modak<subrata@linux.vnet.ibm.com> wrote:
>> On Thu, 2009-03-19 at 12:30 +0530, Subrata Modak wrote:
>>> On Wed, 2009-03-18 at 12:42 -0700, Luis R. Rodriguez wrote:
>>> > On Mon, Mar 16, 2009 at 11:55 PM, Subrata Modak
>>> > <subrata@linux.vnet.ibm.com> wrote:
>>> > > Hi Rahul,
>>> > >
>>> > > On Fri, 2009-03-13 at 22:17 +0530, Subrata Modak wrote:
>>> > >> Hi,
>>> > >>
>>> > >> On Fri, 2009-03-13 at 19:02 +0530, rahul Baliyan wrote:
>>> > >> > Hi,
>>> > >> >
>>> > >> > Pl.  confirm if LTP contains the test cases of W-LAN and WI-FI.
>>> > >>
>>> > >> Nope. We do not have till now. However, we initiated some discussion
>>> > >> some 6 months back in the same mailing list regarding Wireless Mesh
>>> > >> Netwoking tests. Please follow the following thread:
>>> > >>
>>> > >> http://marc.info/?t=121969812900007&r=1&w=2&n=4,
>>> > >>
>>> > >> There are some tests already avilable. We need somebody to volunteer to
>>> > >> bring them to some shape so that they can be automated and then
>>> > >> integrated inside LTP. Would you be ready to do that ?
>>> > >
>>> > > Would you like to take up my proposal ?
>>> >
>>> > BTW I've stashed a Linux wireless testing entry in the Linux
>>> > Foundation GSoC, hopefully that can be merged back into LTP.
>>> >
>>> > https://www.linuxfoundation.org/en/Google_Summer_of_Code_2009#Automation_of_testing_using_mac80211_hwsim_and_Orbit
>>>
>>
>> Hi,
>>
>> Is somebody working on this, and still interested to contribute the same
>> to LTP ?
>
> Yes, the idea is to hopefully contribute it back to LTP. Or have LTP
> use it. I've added Georgy, the student working on this project.
>
>  Luis
>



-- 
Georgy Berdyshev

GPG key: 830F68C5
Fingerprint: 0379 ED5A BEE5 65A8 7BD5  31E7 F5B4 1EC7 830F 68C5
