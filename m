Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:42846 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaIBIGa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 04:06:30 -0400
Received: by mail-pd0-f179.google.com with SMTP id z10so7945554pdj.24
        for <linux-wireless@vger.kernel.org>; Tue, 02 Sep 2014 01:06:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1409644512.1808.2.camel@jlt4.sipsolutions.net>
References: <CAD3NH5X1AYR5p8AyRyO0DFkkJUtuc_78=s6vEi-nS4UxUZfWCg@mail.gmail.com>
	<1409597534.2703.9.camel@jlt4.sipsolutions.net>
	<CAD3NH5Wimu9muPeL-zFrw=u1G3Q+8749cj0SYUmeQuLF6LKibQ@mail.gmail.com>
	<1409644512.1808.2.camel@jlt4.sipsolutions.net>
Date: Tue, 2 Sep 2014 10:06:30 +0200
Message-ID: <CAD3NH5XEfHU7KMWwrmZdZz9LKP_86b4EFogpHrnC+AhREHjOPw@mail.gmail.com> (sfid-20140902_100636_169988_F6C9C2C7)
Subject: Re: wmediumd performance penalty
From: Dani Camps <danicamps81@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

OK, then the results I am getting are indeed surprising. To test
bandwidth I am using an iperf UDP transfer of 100Mbps and around 30
Mbps is all it gets (without wmediumd).

I will further test only mac80211_hwsim (without wmediumd), which I
believe can be used to set up topologies as well with the group
feature as described here:
https://github.com/cozybit/open80211s/wiki/HwsimTestTemplate

Best Regards

Daniel



On Tue, Sep 2, 2014 at 9:55 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2014-09-02 at 09:31 +0200, Dani Camps wrote:
>> Hi,
>>
>> I am running on a virtual machine with Ubuntu. Does mac80211_hwsim not
>> schedule the packet reception time to the other radio(s) according to
>> the PHY rate in the packet in order to simulate transmission time over
>> the air ?
>
> No, it schedules it immediately.
>
> johannes
>
