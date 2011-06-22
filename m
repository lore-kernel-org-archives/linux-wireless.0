Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54345 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757751Ab1FVCDr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 22:03:47 -0400
Received: by vxb39 with SMTP id 39so282456vxb.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 19:03:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110622010057.GA12123@internetdog.org>
References: <776913.88107.qm@web161609.mail.bf1.yahoo.com> <4DC0312A.4040303@lwfinger.net>
 <BANLkTinw+jv8zBi29EKs2K2=tAJMYCEdgQ@mail.gmail.com> <4DC0669E.4040100@lwfinger.net>
 <BANLkTikxS_2wJEpijmYQy3nPy2-9pykxdA@mail.gmail.com> <4DC06BF3.6070208@lwfinger.net>
 <20110621124954.GA8462@internetdog.org> <4E011644.3070906@lwfinger.net> <20110622010057.GA12123@internetdog.org>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 22 Jun 2011 12:03:26 +1000
Message-ID: <BANLkTinD=zRLioxjruqPCMa1hkG4nUxBEw@mail.gmail.com> (sfid-20110622_040351_206681_F65E3722)
Subject: Re: r8712u driver for the rtl8192su chip.
To: ali@internetdog.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ali,

On Wed, Jun 22, 2011 at 11:00, Ali Bahar <ali@internetdog.org> wrote:
> On Tue, Jun 21, 2011 at 05:08:04PM -0500, Larry Finger wrote:
>> On 06/21/2011 07:49 AM, Ali Bahar wrote:
>
>> >this is more of a quick FYI, regarding Staging's r8712u driver.
>
>> >root@hashbang Tue Jun 21 18:30:06 ~$ iwconfig wlan2 essid "h55m"
>> >Error for wireless request "Set ESSID" (8B1A) :
>> >     SET failed on device wlan2 ; Operation not permitted.
>> >root@hashbang Tue Jun 21 18:30:47 ~$ uname -r
>
> How is root unprivileged? The shell-prompt shows the user.

In general, root prompts have a '#' at the end of the prompt, this one
has a '$' which is indicative of a non-privileged user.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
