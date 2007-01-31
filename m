Return-path: <wireless-bounces@tuxdriver.com>
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.178])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0VNskl4015898	for
 <wireless@lists.tuxdriver.org>; Wed, 31 Jan 2007 18:55:12 -0500
Received: by py-out-1112.google.com with SMTP id a29so180593pyi	for
 <wireless@lists.tuxdriver.org>; Wed, 31 Jan 2007 15:54:43 -0800 (PST)
Date: Thu, 01 Feb 2007 01:54:41 +0200
From: Tomas Winkler <tomasw@gmail.com>
Subject: Re: [RFC] cfg80211 merge
In-reply-to: <1170277561.2236.6.camel@johannes.berg>
Sender: wireless-bounces@tuxdriver.com
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wireless@lists.tuxdriver.org
Errors-to: wireless-bounces@tuxdriver.com
Message-id: <1ba2fa240701311554i435d28b1x6822803326138cb5@mail.gmail.com>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="===============1410108754=="
References: <20070131013717.GA28076@tuxdriver.com>
 <20070131024807.GA7061@jm.kir.nu> <20070131182908.13bfc374@griffin.suse.cz>
 <20070131183255.GB8776@tuxdriver.com>
 <20070131202549.5ee47bd4@griffin.suse.cz>
 <20070131200741.GA22448@infradead.org> <20070131204438.GB19669@tuxdriver.com>
 <1170277561.2236.6.camel@johannes.berg>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>

--===============1410108754==
Content-Type: multipart/alternative;
	boundary="----=_Part_10653_256913.1170287681768"

------=_Part_10653_256913.1170287681768
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

As far as I tested cfg80211 compatibility mode is incomplete. You cannot run
hostapd over it
If I recall correctly PRISM2_IOCTL_PRISM2_PARAM and friends are not passed
to d80211

Tomas.

On 1/31/07, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Wed, 2007-01-31 at 15:44 -0500, John W. Linville wrote:
>
> > Agreed.  I (and/or Johannes?) will rework the patches to remove the
> > nl bits.
>
> Starting tomorrow I can devote some time again.
>
> Maybe we should resurrect those wiphy patches I had first?
>
> johannes
>
>
> _______________________________________________
> wireless mailing list
> wireless@lists.tuxdriver.org
> http://lists.tuxdriver.org/mailman/listinfo/wireless
>
>
>
>

------=_Part_10653_256913.1170287681768
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

As far as I tested cfg80211 compatibility mode is incomplete. You cannot run hostapd over it<br>If I recall correctly PRISM2_IOCTL_PRISM2_PARAM and friends are not passed to d80211 <br><br>Tomas.<br><br><div><span class="gmail_quote">
On 1/31/07, <b class="gmail_sendername">Johannes Berg</b> &lt;<a href="mailto:johannes@sipsolutions.net">johannes@sipsolutions.net</a>&gt; wrote:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
On Wed, 2007-01-31 at 15:44 -0500, John W. Linville wrote:<br><br>&gt; Agreed.&nbsp;&nbsp;I (and/or Johannes?) will rework the patches to remove the<br>&gt; nl bits.<br><br>Starting tomorrow I can devote some time again.<br><br>Maybe we should resurrect those wiphy patches I had first?
<br><br>johannes<br><br><br>_______________________________________________<br>wireless mailing list<br><a href="mailto:wireless@lists.tuxdriver.org">wireless@lists.tuxdriver.org</a><br><a href="http://lists.tuxdriver.org/mailman/listinfo/wireless">
http://lists.tuxdriver.org/mailman/listinfo/wireless</a><br><br><br><br></blockquote></div><br>

------=_Part_10653_256913.1170287681768--

--===============1410108754==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless

--===============1410108754==--
