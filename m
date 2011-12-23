Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35445 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab1LWUPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 15:15:35 -0500
Received: by iaeh11 with SMTP id h11so15564828iae.19
        for <linux-wireless@vger.kernel.org>; Fri, 23 Dec 2011 12:15:34 -0800 (PST)
Message-ID: <4EF4E162.5040506@lwfinger.net> (sfid-20111223_211538_442430_7BC95586)
Date: Fri, 23 Dec 2011 14:15:30 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Darshan Nandanwar <dk.manit@gmail.com>
CC: Darshan Kumar NANDANWAR <Darshan.KN@st.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Srikrishna Pramoda ATIKUKKE <srikrishna.pramodaatikukke@st.com>
Subject: Re: insmod RTL8192CE OOPS on 2.6.32.16
References: <D6068D304DED1F4FBFC1F56ECFA211D85A1EA7BBF0@EAPEX1MAIL1.st.com> <4EF1F32F.8070704@lwfinger.net> <20111221151605.GA11842@tuxdriver.com> <4EF235B9.3020805@lwfinger.net> <D6068D304DED1F4FBFC1F56ECFA211D85A1EA7BE7A@EAPEX1MAIL1.st.com> <4EF3559C.9060500@lwfinger.net> <D6068D304DED1F4FBFC1F56ECFA211D85A1EA7C089@EAPEX1MAIL1.st.com> <4EF4AADC.8090204@lwfinger.net> <CAHeY5QcXDdi73nGC5F=-WWHzBzz1W7sj5har4L=_Ah_5xa0yBw@mail.gmail.com>
In-Reply-To: <CAHeY5QcXDdi73nGC5F=-WWHzBzz1W7sj5har4L=_Ah_5xa0yBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/23/2011 12:09 PM, Darshan Nandanwar wrote:
> Larry ,
>   i am using compat-wireless-2011-12-08.tar.bz2
> <http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2011-12-08.tar.bz2>..I
> find the same issue with 8192cU driver as well.. Could you suggest me the commit
> which fixed the issue? i went through your git log , but don't find the issue
> regarding this...
> Once i have the setup ready , i will try to give you debug=4 log .

I'm confused. The 2011-12-08 version of compat-wireless has the patch I sent 
yesterday already built in - you should not have needed to apply it. In fact, it 
should not have applied to that source.

You would only see the git commit log when you have a full git tree from either 
mainline or wireless-testing.

I'm also confused about your statement "I find the same issue with 8192cU driver 
as well.". I guess you must mean that the firmware does not load. If so, do you 
have firmware loading configured in your kernel?

Larry


