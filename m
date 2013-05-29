Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f45.google.com ([209.85.128.45]:56090 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933020Ab3E2DnH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 23:43:07 -0400
Received: by mail-qe0-f45.google.com with SMTP id q19so4765317qeb.4
        for <linux-wireless@vger.kernel.org>; Tue, 28 May 2013 20:43:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6B416C79F6231545B911C08312C479F2F01A@exgmbxfz02.sasken.com>
References: <6B416C79F6231545B911C08312C479F2F01A@exgmbxfz02.sasken.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 29 May 2013 13:42:46 +1000
Message-ID: <CAGRGNgUU8PSi_cExXb=6cytPtqUF0H_WLYi0xcMctQHZbjSiPw@mail.gmail.com> (sfid-20130529_054311_243427_91F3C1CB)
Subject: Re: Compact-wireless build issue
To: Rohini Srinivas <rohini.srinivas@sasken.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rohini,

On Tue, May 28, 2013 at 6:39 PM, Rohini Srinivas
<rohini.srinivas@sasken.com> wrote:
> Hi,
>
> This is Rohini Srinivas from Sasken Communication Technologies, Bangalore. I am trying to build the compact wireless for wilink8 with our dm814x specific ezsdk kernel version 2.6.37.
> We are currently facing issues with regard to the same.
>
> I have followed the steps as mentioned in http://processors.wiki.ti.com/index.php/WL18xx_Build_System_Scripts .Procedure under "System Build Scripts".
>
> The dm81x ezsdk version details - http://processors.wiki.ti.com/index.php/EZSDK_Feature_List .The ezsdk version we are using is 5.04.
>
> As per the README document in compat-wireless downloaded for wilink8 "ol_r8.a6.01" tag, I see that kernel verison > 2.6.24 is compatible. I am trying to build this compact-wireless package with our 2.6.37 kernel, which is failing due to some variables been referred which are added post 3.2 kernel.

Firstly, some of the drivers, and the TI driver may be one of them,
depend on a newer kernel version than the base compat-wireless
package.

Secondly, you're using a version of compat-wireless that's been
provided by TI, rather than an official one, so the only help we can
really give you is to ask if you've tried a newer official version.
You should start reading here:

https://backports.wiki.kernel.org/index.php/Main_Page

Thanks,

--
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
