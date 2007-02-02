Return-path: <wireless-bounces@tuxdriver.com>
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.176])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l12II8Fk007923	for
 <wireless@lists.tuxdriver.org>; Fri, 02 Feb 2007 13:18:33 -0500
Received: by py-out-1112.google.com with SMTP id a29so450540pyi	for
 <wireless@lists.tuxdriver.org>; Fri, 02 Feb 2007 10:18:05 -0800 (PST)
Date: Fri, 02 Feb 2007 20:18:05 +0200
From: Tomas Winkler <tomasw@gmail.com>
Subject: Re: [RFC] cfg80211 merge
In-reply-to: <1170339078.22420.3.camel@johannes.berg>
Sender: wireless-bounces@tuxdriver.com
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, wireless@lists.tuxdriver.org
Errors-to: wireless-bounces@tuxdriver.com
Message-id: <1ba2fa240702021018m2dda838dyb85e956e42694e72@mail.gmail.com>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="===============1050204710=="
References: <20070131013717.GA28076@tuxdriver.com>
 <20070131183255.GB8776@tuxdriver.com>
 <20070131202549.5ee47bd4@griffin.suse.cz>
 <20070131200741.GA22448@infradead.org> <20070131204438.GB19669@tuxdriver.com>
 <1170277561.2236.6.camel@johannes.berg>
 <1ba2fa240701311554i435d28b1x6822803326138cb5@mail.gmail.com>
 <1170335262.17068.6.camel@johannes.berg>
 <1ba2fa240702010604o3cc827d6j1319579e15f28b48@mail.gmail.com>
 <1170339078.22420.3.camel@johannes.berg>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>

--===============1050204710==
Content-Type: multipart/alternative;
	boundary="----=_Part_17012_20613327.1170440285814"

------=_Part_17012_20613327.1170440285814
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Johannes
I don't know who is missing something here, but what I'm saying that (1) is
not correct. priv ioctls don't work with compatibility  set on.
In any case I'll check it again to be sure and I will apologize if I'm not
correct.
I definitely agree on two other  points.

Thanks
Tomas


On 2/1/07, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Thu, 2007-02-01 at 16:04 +0200, Tomas Winkler wrote:
> > Can you elaborate shortly.  I'm not from time 0 on this list.
>
> Well. cfg80211 will replace the common wext ioctls. All the private wext
> ioctls will not be handled there.
>
> The rationale is that
> (1) it doesn't delete priv ioctls, they'll still work for the migration
>      period
> (2) you can't rely on private ioctls having a certain meaning for each
>      driver, ie. other drivers are free the reassign numbers of
>      sub-ioctls
> (3) any behaviour that is generally useful should be standardised.
>
> johannes
>
>
>

------=_Part_17012_20613327.1170440285814
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Johannes<br>I don&#39;t know who is missing something here, but what I&#39;m saying that (1) is not correct. priv ioctls don&#39;t work with compatibility&nbsp; set on. <br>In any case I&#39;ll check it again to be sure and I will apologize if I&#39;m not correct.
<br>I definitely agree on two other&nbsp; points. <br><br>Thanks<br>Tomas<br><br><br><div><span class="gmail_quote">
On 2/1/07, <b class="gmail_sendername">Johannes Berg</b> &lt;<a href="mailto:johannes@sipsolutions.net" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">johannes@sipsolutions.net</a>&gt; wrote:</span>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
On Thu, 2007-02-01 at 16:04 +0200, Tomas Winkler wrote:<br>&gt; Can you elaborate shortly.&nbsp;&nbsp;I&#39;m not from time 0 on this list.<br><br>Well. cfg80211 will replace the common wext ioctls. All the private wext<br>ioctls will not be handled there.
<br><br>The rationale is that<br> (1) it doesn&#39;t delete priv ioctls, they&#39;ll still work for the migration<br>&nbsp;&nbsp;&nbsp;&nbsp; period<br> (2) you can&#39;t rely on private ioctls having a certain meaning for each<br>&nbsp;&nbsp;&nbsp;&nbsp; driver, ie. other drivers are free the reassign numbers of
<br>&nbsp;&nbsp;&nbsp;&nbsp; sub-ioctls<br> (3) any behaviour that is generally useful should be standardised.<br><br>johannes<br><br><br></blockquote></div><br>


------=_Part_17012_20613327.1170440285814--

--===============1050204710==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless

--===============1050204710==--
